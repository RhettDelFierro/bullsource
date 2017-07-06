import React, {Component} from "react";
import {EditorBlock} from 'draft-js';
import {graphql} from "react-apollo";
import checkDOIQuery from "../../../queries/checkDOI";
import {updateEntityOfBlock} from "../../../helpers/forms";
import {organizeReferenceEntityData, compose, replaceEntityData} from "../../../helpers/data";
import styles from "./style.css";

class ReferenceBlock extends Component {
    componentWillUpdate(nextProps) {
        const {blockProps, contentState} = this.props;
        const {onChange, getEditorState} = blockProps;
        const entityKey = contentState.getLastCreatedEntityKey();
        const entity = this.props.contentState.getEntity(
            this.props.block.getEntityAt(0)
        );
        const {fetched} = entity.getData();
        if (!this.props.data.doi && nextProps.data.doi && !fetched) {
            console.log('ceached if statement');
            const {doi} = nextProps.data;
            const editorState = getEditorState();
            const contentStateWithNewEntity = updateEntityOfBlock(editorState)(entityKey);
            let newContentState = compose(contentStateWithNewEntity,organizeReferenceEntityData);

            onChange(newContentState(doi));
        }
        else if (!this.props.data.error && nextProps.data.error) {
            console.log('error', nextProps.data.error);
            //don't want to set data of an error. Maybe you just want to delete this block. Or go back to rendering the reference block but with an error message?
        }
        // if (fetched) {
        //     const editorState = getEditorState();
        //     const selection = editorState.getSelection();
        //     const afterBlock = editorState.getCurrentContent().getBlockAfter(selection.getAnchorKey());
        //     // console.log('block type:', currentBlock.getType());
        //     onChange(resetBlockType(editorState, 'unstyled'))
        // }
    }

    renderWork() {
        const entity = this.props.contentState.getEntity(
            this.props.block.getEntityAt(0)
        );
        const data = entity.getData();
        return this.props.data.error ? <div>Error</div> :
                <div className={styles['work-info']}>
                    <a href={data.get('url')}>{data.get('title')}</a>
                    <p>{data.get('doi')}</p>
                    <p>{data.get('source')}</p>
                    <p>{data.get('date')}</p>
                    <p>{data.get('authors')}</p>
                </div>
    }

    render() {
        // const entity = this.props.contentState.getEntity(
        //     this.props.block.getEntityAt(0)
        // );
        // const {fetched} = entity.getData();
        const {loading} = this.props.data;
        return (
            loading ?
                <div>Loading</div>
                :
                this.renderWork()

        )
    }


}
export default graphql(checkDOIQuery, {
    skip: (props) => {
        const entity = props.contentState.getEntity(
            props.block.getEntityAt(0)
        );
        const {fetched} = entity.getData();

        return fetched
    },
    options: (props) => {
        const entity = props.contentState.getEntity(
            props.block.getEntityAt(0)
        );
        const {fetched,doi} = entity.getData();
        // console.log('doi', doi, fetched);
        // const {block} = props;
        // const data = block.getData();
        // const doi = data.get('doi');
        return {variables: {doi}}
    }
})(ReferenceBlock);
// export default graphql(checkDOIQuery, {
//     options: (props) => {
//         const {block} = props;
//         const data = block.getData();
//         const doi = data.get('doi');
//         return {variables: {doi}}
//     }
// })(ReferenceBlock);