import React, {Component} from "react";

import {Tweets} from "../../sfc/tweets/tweets";


class TweetsContainer extends Component {
    constructor(props) {
        super(props);
        this.state = {hideTweets: true}
    }

    toggle() {
        this.setState({hideTweets: !this.state.hideTweets})
    }

    render() {

        if (this.props.data.loading) {
            return <div>Loading...</div>
        }

        return (

            <Tweets toggle={this.toggle.bind(this)} hideTweets={this.state.hideTweets} tweets={this.props.tweets}/>

        )

    }
}

export default TweetsContainer;