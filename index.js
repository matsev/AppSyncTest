"use strict";
/**
 * This shows how to use standard Apollo client on Node.js
 * Copied from https://docs.aws.amazon.com/appsync/latest/devguide/building-a-client-app-javascript.html
 */

global.WebSocket = require('ws');
global.window = global.window || {
    setTimeout: setTimeout,
    clearTimeout: clearTimeout,
    WebSocket: global.WebSocket,
    ArrayBuffer: global.ArrayBuffer,
    addEventListener: function () { },
    navigator: { onLine: true }
};
global.localStorage = {
    store: {},
    getItem: function (key) {
        return this.store[key]
    },
    setItem: function (key, value) {
        this.store[key] = value
    },
    removeItem: function (key) {
        delete this.store[key]
    }
};
require('es6-promise').polyfill();
require('isomorphic-fetch');

// Require exports file with endpoint and auth info
const aws_exports = require('./AppSync');

// Require AppSync module
const AWSAppSyncClient = require('aws-appsync').default;

const url = aws_exports.graphqlEndpoint;
const region = aws_exports.region;
const type = aws_exports.authenticationType;

// If you want to use API key-based auth
const apiKey = aws_exports.apiKey;

// Import gql helper and craft a GraphQL query
const gql = require('graphql-tag');
const query = gql(`
query que($name: String!) {
greet(name: $name) {
    greeting
}
}`);

const subquery = gql(`
subscription sub { 
greeted { 
    greeting 
} 
}`);


// Set up Apollo client
const client = new AWSAppSyncClient({
    url: url,
    region: region,
    auth: {
        type: type,
        apiKey: apiKey
    }
});


client.hydrated().then(function (client) {
    //Now run a query
    client.query({
            query: query,
            variables: { name: 'AppSync'}
        })
        .then(function logData(data) {
            console.log('results of query: ', data);
        })
        .catch(console.error);

    //Now subscribe to results
    const observable = client.subscribe({ query: subquery });

    const realtimeResults = function realtimeResults(data) {
        console.log('realtime data: ', data);
    };

    observable.subscribe({
        next: realtimeResults,
        complete: console.log,
        error: console.log,
    });
});