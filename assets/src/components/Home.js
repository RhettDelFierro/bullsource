import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from 'react-apollo';

import newsTweetQuery from '../queries/fetchNewsTweet'


class Home extends Component {
    renderNewsTweets(){
      return this.props.data.newsTweet.map(newsTweet => {
          return (
              <div key={`${newsTweet.network.id}  ${newsTweet.news.title}`}>
                <img src={newsTweet.news.urlToImage} />
                <p><b>{newsTweet.network.name}</b> {newsTweet.news.title}</p>
                  <div>
                      {newsTweet.tweets.map(tweet => <li key={tweet.id_str}><b>{tweet.user.name}</b> {tweet.fullText} <b>{tweet.retweetCount}</b> {`${tweet.retweeted}`}</li>)}
                  </div>
              </div>
          )
      })
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