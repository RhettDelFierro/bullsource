import React, { Component } from 'react';
import { graphql } from 'react-apollo'

import headlineMutation from "../../mutations/createHeadline"
import postMutation from "../../mutations/createPost"

class PostForm extends Component {
    constructor(props) {
        super(props)

        this.state = {
            
        }
    }


    onSubmit(event){

    }

    render() {
        return (
            <div>
                <form onSubmit={this.onSubmit.bind(this)}>
                    <label>Song Title:</label>
                    <input
                        onChange={event => this.setState({ title: event.target.value })}
                        value={this.state.title}
                    />

                </form>
                The PostForm goes here.
            </div>
        )
    }
}

// we'll create this as a headline first, then run the approriate mutation
//   - maybe graphql(postMutation)(graphql(headlineMutation)(PostForm)) ??

// maybe write a query to run a check in database if this is a headline?
export default graphql(headlineMutation)(PostForm);