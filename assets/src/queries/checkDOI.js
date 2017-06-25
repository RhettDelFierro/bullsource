import gql from "graphql-tag";

export default gql`
  query doi($doi: String!){
    doi(doi: $doi) {
      author{
        given
        affiliation{
          name
        }
      }
      issn
      title
    }
  }
`;