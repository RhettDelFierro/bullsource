import React, {Component} from "react";
import { graphql } from "react-apollo";
import {Link, withRouter} from "react-router-dom";

import PostForm from '../post_form/PostForm';
import fetchThread from "../../queries/fetchThread";
import signUpMutation from "../../mutations/signup"

class Discussion extends Component {
    //make will get props from the /category/:category/:headline_id # see the router.
    render() {

        return (
            <div>
              <PostForm/>
            </div>
        )

    }
}

export default graphql(signUpMutation)(withRouter(Discussion));