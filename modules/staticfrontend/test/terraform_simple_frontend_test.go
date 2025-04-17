package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformPlanSimpleFrontend(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/simple_frontend",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)
	frontendURL := terraform.Output(t, terraformOptions, "frontend_url")
	assert.Equal(t, "https://simplestaticfrontend.padok.tech", frontendURL)
}
