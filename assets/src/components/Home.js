import React, {Component} from "react";
import gql from "graphql-tag";
import { graphql } from 'react-apollo';


class Home extends Component {
    render() {
        return (
            <div>
                Home
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
      }
      news{title}
      tweets{retweetCount, id, retweetedStatus{fullText}, user{name}}
    }
  }
`;

export default graphql(query)(Home);