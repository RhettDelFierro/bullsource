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

    componentWillMount() {
        // console.log('componentWilReceivePropssssss - next{rops', nextProps);
        // if (nextProps.isFirstPost) {
        const {newsTweet, topicId} = this.props;
        const {network, news, tweets} = newsTweet;

        this.setState({
            title: news.title,
            network: network.name,
            topicId: topicId || '', // will be the topic/category and a number based on the category.
            url: news.url,
            description: news.description,
            publishedAt: news.publishedAt,
        })
        // }
    }

    handlePostBodyChange(event) {
        let post = {...this.state.post};
        post.intro = event.target.value;
        this.setState({post})
    }


    onSubmit(event) {
        event.preventDefault();
        //attempt mutation:
        this.props.mutate({
            variables: {
                title: this.state.title,
                network: this.state.network,
                topicId: this.state.topicId,
                url: this.state.url,
                description: this.state.description,
                publishedAt: this.state.publishedAt,
                post: this.state.post,

            },
            refetchQueries: [{query: newsTweetQuery}]
        }).then((response) => {
            let token = response.data.registerUser.token;
            localStorage.setItem('token', token);
            this.props.history.push("/");
        })
            .catch((e) => {
                console.log('error', e);
            })
    }

    render() {
        console.log("initial propssssss", this.props);
        return (
            <div>
                <form onSubmit={this.onSubmit.bind(this)}>
                    <label>Post:</label>
                    <input
                        onChange={this.handlePostBodyChange.bind(this)}
                        value={this.state.post.intro}
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