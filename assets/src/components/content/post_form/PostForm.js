import React, {Component} from "react";
import {graphql} from "react-apollo";

import headlineMutation from "../../../mutations/createHeadline";
import fetchFullDiscussion from "../../../queries/fetchFullDiscussion";
import FormEditor from "../form_editor/FormEditor";

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
            intro: '',
            post: {
                intro: '',
                proofs: []
            }
        };

        this.setProofs = (proof) => {
            let post = this.state.post;
            post['proofs'] = [proof, ...post.proofs];
            this.setState({post})
        };

        this.setPostIntro = (body) => {
            let post = this.state.post;
            post['intro'] = body;
            this.setState({post})
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
            refetchQueries: [{query: fetchFullDiscussion}]
        }).then((response) => {
            console.log(response);
        })
            .catch((e) => {
                console.log('error', e);
            })
    }

    render() {
        return (
            <div>
                <FormEditor setPostIntro={this.setPostIntro} setProofs={this.setProofs} onSubmit={this.onSubmit.bind(this)}/>
            </div>
        )
    }
}

// we'll create this as a headline first, then run the approriate mutation
//   - maybe graphql(postMutation)(graphql(headlineMutation)(PostForm)) ??

// maybe write a query to run a check in database if this is a headline?
export default graphql(headlineMutation)(PostForm);