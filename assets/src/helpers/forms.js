import {Map} from 'immutable';

const DOI_BLOCK = 'doi_block';


/* The block renderer function applied to each block in draft-js editor component
*
* Parameters
*   getEditorState :: EditorState                  -/>  snapshot of the state of the editor.
*   onChange       :: EditorState -> Object -> ()  -/>  create and set new EditorState objects
*
* Returns
*   ContentBlock -> Object
* */
export const getBlockRendererFn = (getEditorState, onChange, component) => (block) => {
    const type = block.getType();
    switch(type) {
        case DOI_BLOCK:
            return {
                component: component,
                props: {
                    getEditorState,
                    onChange,
                }
            };
        default:
            return null;
    }
};

/* Updates the current state of DOI content block when the user confirms the doi fetch from query.
*
* Parameters
*   getEditorState :: EditorState  -/>  snapshot of the state of the editor.
*   block          :: Map          -/>  block-level metadata
*   newData        :: Map          -/>  new meta data to be set for this block.
*
* Returns
*   EditorState    -/> new editor state for DOIBlock component which wil be set as the new currentContent.
**/
const updateDataOfBlock = (editorState, block, newData) => {
    const contentState = editorState.getCurrentContent();
    const newBlock = block.merge({
        data: newData,
    });
    const newContentState = contentState.merge({
        blockMap: contentState.getBlockMap().set(block.getKey(), newBlock),
    });
    return EditorState.push(editorState, newContentState, 'change-block-type');
};

/* Returns the metadata for a block type. Only have doi right now.
*
*
*
* */
const getDefaultBlockData = (blockType, initialData = {}) => {
    switch (blockType) {
        case DOI_BLOCK: return { verified: false };
        default: return initialData;
    }
};