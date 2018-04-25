# AppSync Test

This is a demo project to test [AWS AppSync](https://aws.amazon.com/appsync/) together with a [AWS CloudFormation](https://aws.amazon.com/cloudformation/).


## Step by step


1. Create the backend infrastructure by executing the [deploy.sh](./deploy.sh) script:

        $ ./deploy.sh --stack-name HelloAppSyncWorld
    
2. Verify that the application was installed successfully by executing the [test.sh](./test.sh) script:

        $ ./test.sh --name Apple
        {"data":{"greet":{"greeting":"Hello Apple!"}}}

3. Download the AppSync configuration
   1. Log into the AWS Console
   2. Go the `AppSync` service
   3. Click on the `Hello World API`
   4. Scroll down and press the `Download` button
   5. Copy the `AppSync.json` file to the root folder of this project
   
4. Install dependencies `npm install`

5. Start the application by running `npm start`:

        $ npm start
        [...]
        > node index.js
        
        results of query:  { data: 
           { greet: { greeting: 'Hello AppSync!', __typename: 'Greeting' } },
          loading: false,
          networkStatus: 7,
          stale: false }

6. Leave this terminal open, start a new terminal window and execute the [test.sh](./test.sh) script again:

        $ ./test.sh --name Carrot
        {"data":{"greet":{"greeting":"Hello Carrot!"}}}
         
7. Return to the first terminal and see that the subscription is working:
        
        realtime data:  { data: 
           { greeted: { greeting: 'Hello Carrot!', __typename: 'Greeting' } } }
        