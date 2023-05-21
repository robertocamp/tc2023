## Building Event-Driven Applications with Amazon EventBridge
### AWS EventBridge Overview
- Amazon EventBridge is a serverless event bus service that makes it easier to build event-driven applications at scale using events from your applications, integrated SaaS partners, and AWS services.
-  You can deliver events to many AWS services, including AWS Lambda and Amazon Simple Notification Service (Amazon SNS), and other SaaS applications. 
- Since EventBridge is a serverless offering, you pay only for the events you publish to your event bus.
- **Amazon EventBridge was previously Amazon CloudWatch Events**
> in a nutshell: *Event producers send events to EventBridge to be delivered to other event consumers*

### EventBridge features
- EventBridge is a fully managed service that handles event ingestion, delivery, security, and authorization
- Using EventBridge, you decouple event producers from event consumers, so each component of the system can independently scale while events are filtered and routed
- EventBridge makes it easier to integrate services without needing custom integration logic to connect to individual services.

### EventBridge Key Components
- An *event* is an indicator of a change in state; events are immutable facts that have occurred in the past.
- An *event bus* is a pipeline that receives events.
- events typically come from three sources:
  * an AWS service
  * a SaaS partner
  * a custom application or service
- example events:
  * An event is sent when an Amazon CloudWatch alarm changes from the state of OK to ALARM.
  * An event can be initiated when an Amazon Elastic Block Store (Amazon EBS) volume snapshot notification occurs.
  * A new Amazon Simple Storage Service (Amazon S3) object being created sends an event.

- You always have a *default event bus* in your AWS account
- To receive events from *SaaS partners*, you create a *partner event source* to connect the SaaS partner to a *partner event bus*
- A *rule* matches incoming events on a specified event bus and routes them to targets for processing.
- A *target* is a resource where EventBridge sends events when a rule's event pattern matches.
  * You can associate multiple targets for a rule 

- how does EventBridge receive and deliver events.
  - An event bus receives an event. 
  - Then, a rule evaluates the event to see if it matches the event pattern. 
  - If the pattern matches, the event is delivered to a target.

### EventBridge Use Cases
- Event-driven architectures use events to communicate between decoupled producers and consumers, and are common in modern applications built with microservices.

### AWS CLI
- Amazon EventBridge helps you to respond to state changes in your Amazon Web Services resources. 
- When your resources change state, they automatically send events to an event stream. - You can create rules that match selected events in the stream and route them to targets to take action. 
- You can also use rules to take action on a predetermined schedule. 
- For example, you can configure rules to:
  * Automatically invoke an Lambda function to update DNS entries when an event notifies you that Amazon EC2 instance enters the running state
  * Direct specific API records from CloudTrail to an Amazon Kinesis data stream for detailed analysis of potential security or availability risks
  * Periodically invoke a built-in target to create a snapshot of an Amazon EBS volume
- to list all the event buses in your account, including the default event bus, custom event buses, and partner event buses:
- aws events list-event-buses

### AWS EventBridge application design
- EventBridge is a highly scalable event router, designed to process events between event producers and consumers. 
- This decouples the event producers from needing to know who consumes the events, and also makes communication asynchronous.
- EventBridge rules listen and identify events with specified event patterns. 
- Upon matching an event in the event bus, events are passed to the appropriate destinations.
- EventBridge events can be passed to AWS services, including other EventBridge event buses and HTTP endpoints, which can send data to SaaS applications
- EventBridge can sit between front-end (customer-facing) applications and backend databases like DynamoDB
- EventBridge rules can send events to a **Lambda function** and **external HTTP endpoints** for processing order details in parallel to support separate components of the application

###  Constructing AWS EventBridge rules
- Events are represented as JSON objects and they all have a similar structure and the same top-level fields
- *Event patterns* are JSON objects with the same structure of the event that it is matching.
- For an event pattern to match an event, the event must contain all the field names listed in the event pattern

### Scheduling AWS EventBridge rules
- EventBridge supports scheduling using a cron or rate expression.
- **note:** All scheduled events use UTC+0 time zone, and the minimum precision for a schedule is 1 minute

### AWS EventBridge API integration
- EventBridge can integrate *API destinations*
  * URL
  * http method
  * authentication method

### EventBridge sources
- AWS services
  * Many AWS services integrate directly with EventBridge
  * events from those services are sent to your account’s default event bus.
  * For services that don’t directly integrate with EventBridge, *the AWS CloudTrail service can be used as a method of initiating rules off of CloudTrail API calls*
- SaaS partners
- Custom Applications

### EventBridge integrations
- You can use the AWS SDKs and AWS Command Line Interface (AWS CLI) to call the PutEvents API to send custom events to EventBridge.
- Sending events between AWS services is a common requirement for decoupled applications. 
- In an example scenario, AnyCompany needs to send events from their ordering service to a loyalty rewards program that is built on AWS Lambda and Amazon DynamoDB. 
- *You can configure targets to invoke AWS services using the EventBridge console or using the PutTargets API*

### EventBridge targets
- EventBridge targets include many AWS services, EventBridge event buses in the same or different AWS accounts, and making calls to API destinations
- To send events to another account or Region, the target for your rule needs to be another event bus
- Sending events to another event bus is used in multiple use cases, such as workloads that span multiple Regions or aggregating events from multiple Regions into one Region
- *To send or receive EventBridge events in another AWS account, the receiver account must grant permission on the target event bus to allow the sending account or organization to send events to the account*
- when possible and to avoid unintended coupling, use a single target for each rule.

### EventBridge input transformation
- AWS Lambda function

### EventBridge pipes
Amazon EventBridge Pipes lets you create Point-to-Point Integrations Between Event Producers and Consumers

### EventBridge: security and identity management
- EventBridge uses AWS IAM to manage both *identity based* and *resource based* policies
- Dead Letter Queue ("DL Queue")
- EventBridge provides encryption at rest and in transit by default.
  * encryption at rest: 256-bit Advanced Encryption Standard (AES-256) under an AWS owned key.
  * encryption in transit: EventBridge encrypts data that passes between EventBridge and other services by using Transport Layer Security (TLS).

#### IAM policies for EventBridge
- The type of policy required to grant permission to the EventBridge service can vary from service to service. 
- For example, API Gateway requires you to attach a *resource-based policy* to the API Gateway endpoint, allowing for the EventBridge service "events.amazonaws.com" to run the required actions. 
- Other services only require an *identity-based policy* that will be attached to an IAM role. 
  * This role is assumed by the EventBridge service when the rule is invoked and will have the required permissions to call the target service.
- AWS addresses many common use cases by providing standalone IAM policies that are created and administered by AWS
  * these are called *AWS managed policies*

##### resource-based policies
- For resource-based policies, conditions limit which EventBridge rules are allowed to call other services
##### identity-based policies
- Whether attached to a user, group, or role that will be assumed by an AWS service, *identity-based policies are attached to the identity accessing the target service*
- When EventBridge needs to access targets such as API destination, a Kinesis stream, a Systems Manager Run Command, an AWS Step Functions state machine, or an Amazon Elastic Container Service (Amazon ECS) task, you must specify an IAM role for accessing that target with a policy containing the appropriate permissions

### AWS EventBridge reliability
- If you don't configure your own retry policy, EventBridge has a default retry policy, which will retry sending the event for 24 hours and up to 185 times

#### DLQ
- Dead-letter queues store messages or events that could not be processed correctly
- EventBridge DLQs are integrated into the service and are standard Amazon Simple Queue Service (Amazon SQS) queues that store events that EventBridge could not successfully deliver to their targets



## links
https://aws.amazon.com/blogs/compute/introducing-amazon-eventbridge-scheduler/
https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-putevents.html#eb-send-events-aws-cli
https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-tutorial-get-started.html
https://docs.aws.amazon.com/lambda/latest/dg/lambda-golang.html