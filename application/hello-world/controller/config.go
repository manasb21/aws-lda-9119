package controller

import (
	"os"
)

type envConfig struct {
	environment string
}

// NewConfigFromEnv -
func NewConfigFromEnv() *envConfig {

	return &envConfig{
		environment: os.Getenv("ENVIRONMENT"),
	}
}
