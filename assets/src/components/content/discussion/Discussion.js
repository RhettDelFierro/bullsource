import React, {Component} from "react";
import {graphql} from "react-apollo";
import {withRouter} from "react-router-dom";

import HeadlineDetails from "../../sfc/headline_details/HeadlineDetails";
import PostForm from "../post_form/PostForm";

import fetchFullDiscussion from "../../../queries/fetchFullDiscussion";

class Discussion extends Component {

    //make will get props from the /category/:category/:headline_id # see the router.
    render() {
        if (this.props.data.loading) {
            return <div>Loading...</div>
        }

        // const isThread = this.props.data. ####check if this is a thread, then can pass prop to postform.
        const logged_in = this.props.data.currentUser ? <PostForm newsTweet={this.props.data.newsTweet}/> : '';

        //render the rest of the posts after {logged_in}
        return (
            <div>
                <HeadlineDetails newsTweet={this.props.data.newsTweet}/>
                {logged_in}
            </div>
        )
    }
}

export default graphql(fetchFullDiscussion, {
    options: (props) => {
        const {headline_title, network} = props.match.params;
        const title = headline_title.split("_").join(' ');

        return {variables: {title, network}}
    }
})(withRouter(Discussion));