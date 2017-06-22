import React, {Component} from "react";

import {Tweets} from "../../sfc/tweets/tweets";


class TweetsContainer extends Component {
    constructor(props) {
        super(props);
        this.state = {showTweets: false}
    }

    toggle() {
        this.setState({hideTweets: !this.state.hideTweets})
    }

    render() {

        return (
            <Tweets toggle={this.toggle.bind(this)} showTweets={this.state.hideTweets} tweets={this.props.tweets}/>
        )

    }
}

export default TweetsContainer;