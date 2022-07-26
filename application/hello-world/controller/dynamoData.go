package controller

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"os"
)

func DynamoGetItem() *dynamodb.GetItemOutput {
	cfg, err := config.LoadDefaultConfig(context.TODO(), func(o *config.LoadOptions) error {
		o.Region = os.Getenv("REGION")
		return nil
	})
	if err != nil {
		panic(err)
	}
	svc := dynamodb.NewFromConfig(cfg)
	out, err := svc.GetItem(context.TODO(), &dynamodb.GetItemInput{
		TableName: aws.String(os.Getenv("TABLE_NAME")),
		Key: map[string]types.AttributeValue{
			"env": &types.AttributeValueMemberS{Value: os.Getenv("ENVIRONMENT")},
		},
	})

	if err != nil {
		panic(err)
	}
	return out
}
