import React from "react";
import ReactDOM from "react-dom";
import {BrowserRouter, Route, Switch} from "react-router-dom";
import ApolloClient, {createNetworkInterface} from "apollo-client";
import {ApolloProvider} from "react-apollo";

import Header from "./components/header/header/header";
import SidePanel from "./components/side/side_panel/side_panel";
import Categories from "./components/content/categories/Categories";
import Discussion from "./components/content/discussion/Discussion";
import Home from "./components/content/home/Home";
import SignIn from "./components/side/signin/SignIn";
import SignUp from "./components/side/signup/SignUp";
import DraftJSTest from "./test"


import styles from "./style.css";

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
    networkInterface, // our customized networkInterface rather than the default networkInterface that Apollo uses.
    dataIdFromObject: o => o.id
});


const Root = () => {
    return (
        <ApolloProvider client={client}>
            <BrowserRouter>
                <div className={styles['root-container']}>
                    <Header />
                    <Switch>
                        <Route exact path="/" component={Home}/>
                        <Route path="/signup" component={SignUp}/>
                        <Route path="/signin" component={SignIn}/>
                        <Route exact path="/category/:category" component={Categories}/>
                        <Route path="/category/:category/:network/:headline_title" component={Discussion}/>
                        <Route path="/test" component={DraftJSTest} />
                        <Route render={ () => <p>Not Found</p> }/>
                    </Switch>
                    <SidePanel />
                </div>
            </BrowserRouter>
        </ApolloProvider>
    )
};

ReactDOM.render(
    <Root />,
    document.getElementById('root')
);