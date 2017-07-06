import React, {Component} from "react";
import {EditorBlock} from 'draft-js';
import {graphql} from "react-apollo";
import checkDOIQuery from "../../../queries/checkDOI";
import {updateEntityOfBlock} from "../../../helpers/forms";
import {organizeReferenceEntityData, compose, replaceEntityData} from "../../../helpers/data";
import styles from "./style.css";

class ReferenceBlock extends Component {
    // shouldComponentUpdate(nextProps,nextState){
    //    return this.state.fetched && nextProps.
    // }

    // componentWillUpdate(nextProps) {
    //     const {blockProps, contentState} = this.props;
    //     const {onChange, getEditorState} = blockProps;
    //     const entityKey = contentState.getLastCreatedEntityKey();
    //     const entity = this.props.contentState.getEntity(
    //         this.props.block.getEntityAt(0)
    //     );
    //     const data = entity.getData();
    //
    //     if (!this.props.data.doi && nextProps.data.doi && initialFetch) {
    //         const {doi} = nextProps.data;
    //         const editorState = getEditorState();
    //         const contentStateWithNewEntity = updateEntityOfBlock(editorState)(entityKey);
    //         let newContentState = compose(contentStateWithNewEntity,organizeReferenceEntityData);
    //         onChange(newContentState(doi));
    //         this.setState({fetched: true})
    //     }
    // }

    renderWork() {
        // const entity = this.props.contentState.getEntity(
        //     this.props.block.getEntityAt(0)
        // );
        // const data = entity.getData();
        const {loading} = this.props.data;

        if (loading){
            return <div>Loading</div>
        } else {
            const {doi} = this.props.data;
            const {url, title} = doi[0];
            return (
                <div className={styles['work-info']}>
                    <a href={url}>{title}</a>
                </div>
            )
        }

    }

    render() {
              return this.renderWork()

    }
}

export default graphql(checkDOIQuery, {
    options: (props) => {
        const entity = props.contentState.getEntity(
            props.block.getEntityAt(0)
        );
        const data = entity.getData();
        return {variables: {doi: data.get('doi')}}
    }
})(ReferenceBlock);