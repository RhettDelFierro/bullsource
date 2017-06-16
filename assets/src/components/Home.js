import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from 'react-apollo';


class Home extends Component {
    renderNewsTweets(){
      return this.props.data.newsTweet.map(newsTweet => {
          return (
              <div>
                <img src={newsTweet.news.urlToImage} />
                <p><b>{newsTweet.network.name}</b> {newsTweet.news.title}</p>
                  <div>
                      {newsTweet.tweets.map(tweet => <li><b>{tweet.user.name}</b> {tweet.retweetedStatus.fullText}</li>)}
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

const query = gql`
  {
    newsTweet{
      network{
        id
        name
        url
      }
      news{title, urlToImage}
      tweets{retweetCount, id, retweetedStatus{fullText}, user{name}}
    }
  }
`;

export default graphql(query)(Home);