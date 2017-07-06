import {Map} from 'immutable';

export const compose = (...funcs) => x => {
  return funcs.reduceRight((acc,next) => {
      return next(acc);
  },x)
};

export const pipe = (...funcs) => x => {
  return funcs.reduce((acc,next) => {
      return next(acc);
  }, x)
};

/*Returns a function that waits for the content block
*
* Return:
*  ContentBlock -> Map
* */
export const organizeReferenceData = (doiInfo) => {
    const {url, title, indexed, containerTitle, author, doi} = doiInfo[0];
    const authors = author.map(name => `${name.given} ${name.family}`).join(', ');
    return {
        doi,
        url,
        title: title[0],
        source: containerTitle[0],
        date: `${indexed.dateParts[0][1]}/${indexed.dateParts[0][2]}/${indexed.dateParts[0][0]}`,
        authors
    };
};

// replaceEntityData :: a -> b -> c -> b
export const replaceEntityData = entity => entityKey => data => {
    return entity.replaceData(
        entityKey,
        data
    )
};