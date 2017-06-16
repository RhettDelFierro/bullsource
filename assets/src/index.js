import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import ApolloClient, {createNetworkInterface} from "apollo-client";
import {ApolloProvider} from "react-apollo";
import { Nav } from './components/nav/Nav'


import Home from "./components/Home";
import SignUp from "./components/signup/SignUp";

//create new instance of ApolloClient for the ApolloProvider
const client = new ApolloClient({
    networkInterface: createNetworkInterface({
        uri: 'http://localhost:4000/graphql',
    }),
});

const Root = () => {
    return (
        <ApolloProvider client={client}>
            <BrowserRouter>
                <div>
                    <Nav />
                    <Switch>
                        <Route exact path="/" component={Home}/>
                        <Route path="/signup" component={SignUp}/>
                        <Route render={ () => <p>Not Found</p> }/>
                    </Switch>
                </div>
            </BrowserRouter>
        </ApolloProvider>
    )
};

ReactDOM.render(
    <Root />,
    document.getElementById('root')
);