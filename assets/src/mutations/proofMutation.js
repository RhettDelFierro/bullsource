import gql from "graphql-tag";

export default gql`
 mutation CheckDOI($doi: String!){
  checkDOI(doi: $doi){
    info{

    }
  }
}
`;