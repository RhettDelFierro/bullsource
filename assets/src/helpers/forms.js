import {EditorState} from "draft-js";
const DOI_BLOCK = 'doi_block';


/* The block renderer function applied to each block in draft-js editor component
 *
 * Parameters
 *   getEditorState :: EditorState                  -/>  snapshot of the state of the editor - a function.
 *   onChange       :: EditorState -> Object -> ()  -/>  create and set new EditorState objects
 *
 * Returns
 *   ContentBlock -> Object
 * */
export const getBlockRendererFn =
    (getEditorState, onChange, setProof, onDOIError, component) => (block) => {
        const type = block.getType();
        switch (type) {
            case 'atomic':
                return {
                    component: component,
                    props: {
                        getEditorState,
                        onChange,
                        setProof,
                        onDOIError
                    }
                };
            default:
                return null;
        }
    };
/* Updates the current state of DOI content block when the user confirms the doi fetch from query.
 *
 * Parameters
 *   editorState    :: EditorState  -/>  snapshot of the state of the editor.
 *   block          :: Map          -/>  block-level metadata
 *   newData        :: Map          -/>  new meta data to be set for this block.
 *
 * Returns
 *   EditorState    -/> new editor state for DOIBlock component which wil be set as the new currentContent.
 **/
export const updateDataOfBlock = (editorState, block, newData) => {
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
 *  Parameters
 *    blockType   :: String
 *    initialData :: Object
 *
 *  Return
 *  Object
 * */
export const getDefaultBlockData = (blockType, initialData = {}) => {
    switch (blockType) {
        case DOI_BLOCK:
            return {doi: ''};
        default:
            return initialData;
    }
};

/* Changes the block type of the current block.
 *
 * Parameters
 *   editorState :: EditorState  -/>  snapshot of the state of the editor.
 *
 *
 **/
export const resetBlockType = (editorState, newType = 'unstyled') => {
    const contentState = editorState.getCurrentContent();
    const selectionState = editorState.getSelection();
    const key = selectionState.getStartKey();
    const blockMap = contentState.getBlockMap();
    const block = blockMap.get(key);
    let newText = '';
    const text = block.getText();
    if (block.getLength() >= 2) {
        newText = text.substr(1);
    }
    const newBlock = block.merge({
        text: newText,
        type: newType,
        data: getDefaultBlockData(newType),
    });
    const newContentState = contentState.merge({
        blockMap: blockMap.set(key, newBlock),
        selectionAfter: selectionState.merge({
            anchorOffset: 0,
            focusOffset: 0,
        }),
    });
    return EditorState.push(editorState, newContentState, 'change-block-type');
};
