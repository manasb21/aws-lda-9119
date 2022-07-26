package controller

import (
	"context"
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
)

type Response events.APIGatewayProxyResponse

type Controller interface {
	Run(ctx context.Context, event events.APIGatewayCustomAuthorizerRequest) (Response, error)
}

func (l lambdaController) Run(ctx context.Context, event events.APIGatewayCustomAuthorizerRequest) (Response, error) {
	item := &DynamoDbItem{}
	dynamodbOutput := DynamoGetItem()
	err := attributevalue.UnmarshalMap(dynamodbOutput.Item, &item)
	if err != nil {
		return Response{}, err
	}

	lambdaResponse := LambdaResponse{
		Message: item.Message,
	}

	response, err := json.Marshal(lambdaResponse)

	res := Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Headers: map[string]string{
			"Access-Control-Allow-Origin":      "*",
			"Access-Control-Allow-Credentials": "true",
			"Cache-Control":                    "no-cache; no-store",
			"Content-Type":                     "application/json",
			"Content-Security-Policy":          "default-src self",
			"Strict-Transport-Security":        "max-age=31536000; includeSubDomains",
			"X-Content-Type-Options":           "nosniff",
			"X-XSS-Protection":                 "1; mode=block",
			"X-Frame-Options":                  "DENY",
		},
		Body: string(response),
	}

	return res, err
}

func NewLambdaHandler(
	environment string,
) *lambdaController {
	return &lambdaController{
		environment: environment,
	}
}
