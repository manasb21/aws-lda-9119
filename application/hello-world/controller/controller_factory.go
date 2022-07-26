package controller

func Create() Controller {
	config := NewConfigFromEnv()

	return NewLambdaHandler(config.environment)
}
