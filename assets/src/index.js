import React from "react";
import ReactDOM from "react-dom";
import {ApolloProvider} from "react-apollo";

//create new instance of ApolloClient for the ApolloProvider
const client = new ApolloClient({});

const Root = () => {
    return (
        <ApolloProvider client={client}>
            <div>Bullsource</div>
        </ApolloProvider>
    )
};

ReactDOM.render(
    <Root />,
    document.getElementById('root')
);