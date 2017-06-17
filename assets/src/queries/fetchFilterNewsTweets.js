import gql from "graphql-tag";

export default gql`
  query NewsTweetsBy($category: String!){
    newsTweetsBy(category: $category) {
      network{
        name
      }
      news{
        title
      }
    }
  }
`;