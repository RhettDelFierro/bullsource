import gql from "graphql-tag";

export default gql`
  query doi($doi: String!){
    doi(doi: $doi) {
      author{
        given
        family
        affiliation{
          name
        }
      }
      containerTitle
      doi
      indexed{
        dateParts
        timestamp
      }
      isReferencedByCount
      publisher
      title
      url
      issn
      title
    }
  }
`;