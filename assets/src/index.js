import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import ApolloClient, {createNetworkInterface} from "apollo-client";
import {ApolloProvider} from "react-apollo";

import { CategoryNav } from './components/category_nav/CategoryNav'
import { Nav } from './components/nav/Nav'
import Home from "./components/Home";
import SignUp from "./components/signup/SignUp";
import Categories from "./components/categories/Categories";

//create new instance of ApolloClient for the ApolloProvider
const networkInterface = createNetworkInterface({
    uri: 'http://localhost:4000/graphql',
});

networkInterface.use([{
    applyMiddleware(req, next) {
        if (!req.options.headers) {
            req.options.headers = {};  // Create the header object if needed.
        }
        // get the authentication token from local storage if it exists
        const token = localStorage.getItem('token');
        req.options.headers.authorization = token ? `Bearer ${token}` : null;
        next();
    }
}]);

const client = new ApolloClient({
    networkInterface
});

const Root = () => {
    return (
        <ApolloProvider client={client}>
            <BrowserRouter>
                <div>
                    <CategoryNav />
                    <Nav />
                    <Switch>
                        <Route exact path="/" component={Home}/>
                        <Route path="/signup" component={SignUp}/>
                        <Route path="category/:category" component={Categories}/>
                        {/*this will be for discussion*/}
                        <Route path="/category/:category/:headline_id" component={Discussion}/>
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