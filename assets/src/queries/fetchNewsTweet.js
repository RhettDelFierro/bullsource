import gql from 'graphql-tag'

export default gql`
    {
    newsTweet{
      network{
        id
        name
        url
      }
      news{
        title
        url
      }
      tweets{
        retweetCount, 
        id_str, 
        fullText,
        user{
          name
        },
        retweeted
      }
    }
  }
`;