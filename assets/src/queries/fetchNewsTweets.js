import gql from 'graphql-tag'

export default gql`
    {
    newsTweets{
      network{
        id
        name
        url
        category
      }
      news{
        title
        url
        urlToImage
        publishedAt  
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