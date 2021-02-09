package admin

import (
	"log"
	"os"
	"path/filepath"
	"sync"

	"gopkg.in/yaml.v2"
	"io/ioutil"
)

const (
	environmentEnvVariable            = "ENVIRONMENT"
	versionEnvVariable                = "VERSION"
	configurationDirectoryEnvVariable = "CONFIGURATION_DIRECTORY"
	defaultConfigurationDirectory     = "/configuration"
	configurationFileName             = "config.yaml"
)

type Configuration struct {
	Environment string
	Version     string

	Config EnvironmentConfiguration
}

type EnvironmentConfiguration struct {
	Debug bool
}

// Variable used to store the full configuration as a singleton.
var instance *Configuration
var once sync.Once

// Return the configuration of the application based on the environment we are running in. This will cause an
// application crash if a configuration file doesn't exist, or if it doesn't match with our configuration object
// definition.
func GetConfiguration() *Configuration {
	once.Do(func() {
		environment := os.Getenv(environmentEnvVariable)
		configFilePath := getConfigFilePath(environment)
		configFileContent, err := ioutil.ReadFile(configFilePath)
		if err != nil {
			log.Fatalf("Failed to read configuration file with error %v", err)
		}
		environmentConfiguration := getEnvironmentConfiguration(configFileContent)
		configurationInstance := Configuration{
			Environment: environment,
			Version:     os.Getenv(versionEnvVariable),
			Config:      environmentConfiguration,
		}
		instance = &configurationInstance
	})
	return instance
}

func getEnvironmentConfiguration(configFileContent []byte) EnvironmentConfiguration {
	environmentConfiguration := EnvironmentConfiguration{}
	err := yaml.Unmarshal(configFileContent, &environmentConfiguration)
	if err != nil {
		log.Fatalf("Failed to read configuration file with error %v", err)
	}
	return environmentConfiguration
}

func getConfigFilePath(environment string) string {
	configurationDirectory := os.Getenv(configurationDirectoryEnvVariable)
	if configurationDirectory == "" {
		configurationDirectory = defaultConfigurationDirectory
	}
	configFilePath := filepath.Join(configurationDirectory, environment, configurationFileName)

	_, err := os.Stat(configFilePath)
	if os.IsNotExist(err) {
		log.Fatalf("Failed to find config file at %s", configFilePath)
	}
	return configFilePath
}
