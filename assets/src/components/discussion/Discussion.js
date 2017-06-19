import React, {Component} from "react";
import {graphql} from "react-apollo";
import {withRouter} from "react-router-dom";

import HeadlineDetails from "../headline_details/HeadlineDetails";

import fetchThreadQuery from "../../queries/fetchThread";

class Discussion extends Component {
    //make will get props from the /category/:category/:headline_id # see the router.
    render() {

        if (this.props.data.loading) {
            return <div>Loading...</div>
        }

        const logged_in = this.props.data.currentUser ? <PostForm /> : '';

        return (
            <div>
                <HeadlineDetails newsTweet={this.props.data.newsTweet}/>
                {logged_in}
            </div>
        )

    }
}

export default graphql(fetchThreadQuery, {
    options: (props) => {

        const {headline_id} = props.match.params;
        const title = headline_id.split("_").join(' ');

        return {variables: {title: title}}
    }
})(withRouter(Discussion));