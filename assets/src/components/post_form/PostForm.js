import React, {Component} from "react";
import {graphql} from "react-apollo";

import headlineMutation from "../../mutations/createHeadline";

class PostForm extends Component {
    constructor(props) {
        super(props);

        this.state = {
            title: '',
            network: '',
            topicId: '', // will be the topic/category and a number based on the category.
            url: '',
            description: '',
            publishedAt: '',
            post: {
                intro: '',
                proofs: []
            }

        }
    }

    componentWillReceiveProps(nextProps) {
        console.log(nextProps);
        if (nextProps.isFirstPost) {
            const {newsTweet, topicId} = nextProps;
            const {network, news, tweets} = newsTweet;

            this.setState({
                title: news.title,
                network: network.name,
                topicId: topicId || '', // will be the topic/category and a number based on the category.
                url: news.url,
                description: news.description,
                publishedAt: news.publishedAt,
            })
        }
    }

    handlePostBodyChange(event) {
        let postBody = { ...this.state.post };
        postBody.intro = event.target.value;
        this.setState({postBody})
    }


    onSubmit(event) {

    }

    render() {
        return (
            <div>
                <form onSubmit={this.onSubmit.bind(this)}>
                    <label>Song Title:</label>
                    <input
                        onChange={this.handlePostBodyChange.bind(this)}
                        value={this.state.title}
                    />

                </form>
            </div>
        )
    }
}

// we'll create this as a headline first, then run the approriate mutation
//   - maybe graphql(postMutation)(graphql(headlineMutation)(PostForm)) ??

// maybe write a query to run a check in database if this is a headline?
export default graphql(headlineMutation)(PostForm);