package function

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"time"

	"golang.org/x/oauth2/google"
	sqladmin "google.golang.org/api/sqladmin/v1beta4"
)

// PubSubMessage is the payload of a Pub/Sub event.
// See the documentation for more details:
// https://cloud.google.com/pubsub/docs/reference/rest/v1/PubsubMessage
type PubSubMessage struct {
	Data []byte `json:"data"`
}

type MessagePayload struct {
	Db       string
	Instance string
	Project  string
	Gs       string
}

// ProcessPubSub consumes and processes a Pub/Sub message.
func ProcessPubSub(ctx context.Context, m PubSubMessage) error {
	var psData MessagePayload
	err := json.Unmarshal(m.Data, &psData)
	if err != nil {
		log.Println(err)
	}
	log.Printf("Request received for db export: %s, %s, %s, %s", psData.Db, psData.Instance, psData.Project, psData.Gs)

	// Create an http.Client that uses Application Default Credentials.
	hc, err := google.DefaultClient(ctx, sqladmin.CloudPlatformScope)
	if err != nil {
		return fmt.Errorf("could not create HTTP client: %w", err)
	}

	// Create the Google Cloud SQL service.
	service, err := sqladmin.New(hc)
	if err != nil {
		return fmt.Errorf("could not create SQL client: %w", err)
	}

	// Get current date-time to add to file name of exported file.
	datestamp := time.Now().Format("2006-01-02-1504-05")
	uriPath := fmt.Sprintf("%s/export-%s-%s-%s.sql.gz", psData.Gs, psData.Instance, psData.Db, datestamp)
	// See more examples at:
	// https://cloud.google.com/sql/docs/sqlserver/admin-api/rest/v1beta4/instances/export
	rb := &sqladmin.InstancesExportRequest{
		ExportContext: &sqladmin.ExportContext{
			Kind:      "sql#exportContext",
			Uri:       uriPath,
			FileType:  "SQL",
			Offload:   true,
			Databases: []string{psData.Db},
		},
	}

	resp, err := service.Instances.Export(psData.Project, psData.Instance, rb).Context(ctx).Do()
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("%#v\n", resp)
	return nil
}
