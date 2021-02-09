package admin

import (
	"testing"
)

func TestGetConfiguration(t *testing.T) {
	configuration := GetConfiguration()
	if configuration.Environment != "test" {
		t.Errorf("Expected environment of test, got %s", configuration.Environment)
	}

	if configuration.Version != "1.0.0" {
		t.Errorf("Expected version of 1.0.0, got %s", configuration.Version)
	}

	if configuration.Config.Debug {
		t.Errorf("Expected debug of false, got %t", configuration.Config.Debug)
	}
}
