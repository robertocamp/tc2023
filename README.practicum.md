1. download all course files into the "files" folder (might have start/exit labs in order to do this)

https://www.youtube.com/watch?v=SMWmz1oLqx4
in a typical Lambda flow, you will have a "consumer" and a "producer"
a producer will produce and event and the event will be consumed by a consumer
lambda can be a "consumer" of events from SQS,SNS, or API Gateway
a lambda function call also act as the "producer" and produce the events that other services consume
a lambda can produce and emit events onto queues and publish notifications in SNS that 
producer -> events -> -> consumer

need queue URL
need topic ARN



## links
https://www.youtube.com/watch?v=SMWmz1oLqx4
git@github.com:devtopics-yt/lambda-publish-sns-sqs.git