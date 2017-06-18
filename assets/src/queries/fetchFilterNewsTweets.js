import gql from "graphql-tag";

export default gql`
  query NewsTweetsBy($category: String!){
    newsTweetsBy(category: $category) {
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