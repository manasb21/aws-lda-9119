package controller

type lambdaController struct {
	environment string
}

type LambdaResponse struct {
	Message string
}

type DynamoDbItem struct {
	Env     string `dynamodb:"env"`
	Message string `json:"message"`
}
