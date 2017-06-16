import React from "react";
import ReactDOM from "react-dom";
import ApolloClient, { createNetworkInterface } from "apollo-client";
import {ApolloProvider} from "react-apollo";


import Home from "./components/Home";

//create new instance of ApolloClient for the ApolloProvider
const client = new ApolloClient({
    networkInterface: createNetworkInterface({
        uri: 'http://localhost:4000/graphql',
    }),
});

const Root = () => {
    return (
        <ApolloProvider client={client}>
            <Home />
        </ApolloProvider>
    )
};

ReactDOM.render(
    <Root />,
    document.getElementById('root')
);