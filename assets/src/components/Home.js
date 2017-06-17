import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from 'react-apollo';

import Headline from './headline/Headline';

import newsTweetQuery from '../queries/fetchNewsTweets'


class Home extends Component {
    renderNewsTweets(){
      return this.props.data.newsTweets.map(newsTweet => <Headline newsTweet={newsTweet} />)
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