package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformPlanHello(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/hello",
	})

	// defer Destroy to avoid undeleted resources
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// get the outputs
	outputCommand := terraform.Output(t, terraformOptions, "gcloud_run_deploy_command")
	cloudRunURL := terraform.Output(t, terraformOptions, "cloud_run_url")

	assert.Equal(t, "gcloud run deploy --project gcp-library-terratest --region europe-west3 ci-cloud-run-test", outputCommand)

	http_helper.HttpGetWithRetryWithCustomValidation(t, cloudRunURL, nil, 5, 5*time.Second, func(code int, body string) bool { return code == 200 })
}
