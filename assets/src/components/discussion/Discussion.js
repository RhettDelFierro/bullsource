import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import newsTweetFilterQuery from "../../queries/fetchFilterNewsTweets";
import signUpMutation from "../../mutations/signup"

class Categories extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: '',
            email: '',
            password: '',
            confirm_password: ''
        };
    }

    render() {

        return (
            <div>

            </div>
        )

    }
}

const query = gql`

`;

export default graphql(signUpMutation)(withRouter(Category));