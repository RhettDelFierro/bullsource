import React from "react";
import {NavLink} from "react-router-dom";
import "./style.css";

export const CategoryNav = () => {
    return (
        <div className='category-nav'>
            <NavLink exact activeClassName='active' to='/'>Home</NavLink>
            <NavLink activeClassName='active' to='/category/entertainment'>Entertainment</NavLink>
            <NavLink activeClassName='active' to='/category/gaming'>Gaming</NavLink>
            <NavLink activeClassName='active' to='/category/general'>General</NavLink>
            <NavLink activeClassName='active' to='/category/music'>Music</NavLink>
            <NavLink activeClassName='active' to='/category/politics'>Politics</NavLink>
            <NavLink activeClassName='active' to='/category/science-and-nature'>Science and Nature</NavLink>
            <NavLink activeClassName='active' to='/category/sport'>Sport</NavLink>
            <NavLink activeClassName='active' to='/category/technology'>Technology</NavLink>
        </div>
    )
};

