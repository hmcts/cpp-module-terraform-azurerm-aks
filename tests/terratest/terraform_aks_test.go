package test

import (
	"testing"
	"fmt"
	"strings"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestAksCluster(t *testing.T) {
	t.Parallel()

	fixtureFolder := "./fixture"

	// At the end of the test, clean up any resources that were created
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, fixtureFolder)

		// Save the options so later test stages can use them
		test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

		// This will init and apply the resources and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	// Check whether the length of output meets the requirement
	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		randomID := terraform.Output(t, terraformOptions, "random_id")
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		subscriptionID := terraform.Output(t, terraformOptions, "subscription_id")
		expectedClusterName := fmt.Sprintf("K8-TEST-APPS01-01-%s", randomID)
		expectedSysAgentPoolName := "sysagentpool"
		expectedSysAgentPoolCount := 2

		aksID := terraform.Output(t, terraformOptions, "test_aks_id")
		if len(aksID) <= 0 {
			t.Fatal("Wrong output")
		}

		// Look up the cluster details
		// Managed cluster model https://github.com/Azure/azure-sdk-for-go/blob/v67.0.0/services/containerservice/mgmt/2019-11-01/containerservice/models.go
		cluster, err := azure.GetManagedClusterE(t, resourceGroupName, expectedClusterName, subscriptionID)
		require.NoError(t, err)
		ActualsysAgentPoolName := *(*cluster.ManagedClusterProperties.AgentPoolProfiles)[1].Name
		ActualsysAgentPoolCount := *(*cluster.ManagedClusterProperties.AgentPoolProfiles)[1].Count
		ActualdnsPrefix := (*cluster.ManagedClusterProperties.DNSPrefix)
		ActualFqdn := (*cluster.ManagedClusterProperties.PrivateFQDN)

		// Test that cluster properties matches the Terraform specification

		assert.Equal(t, expectedSysAgentPoolName, ActualsysAgentPoolName)
		assert.Equal(t, int32(expectedSysAgentPoolCount), ActualsysAgentPoolCount)
		assert.Equal(t, expectedClusterName, ActualdnsPrefix)
		fqdnResult := strings.Contains(ActualFqdn, strings.ToLower(expectedClusterName))
		assert.Equal(t, true, fqdnResult)

	})


}

func configureTerraformOptions(t *testing.T, fixtureFolder string) *terraform.Options {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fixtureFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},
	}

	return terraformOptions
}
