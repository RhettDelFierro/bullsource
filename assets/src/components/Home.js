import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from 'react-apollo';

import Headline from './headline/Headline';

import newsTweetQuery from '../queries/fetchNewsTweet'


class Home extends Component {
    renderNewsTweets(){
      return this.props.data.newsTweet.map(newsTweet => <Headline newsTweet={newsTweet} />)
    }

    render() {

        if (this.props.data.loading) {return <div>Loading...</div>}

        return (

            <div>
                {this.renderNewsTweets()}
            </div>
        )

    }
}

export default graphql(newsTweetQuery)(Home);