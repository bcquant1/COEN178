CREATE TABLE MovieReviews(
    movieName VARCHAR(25),
    comments VARCHAR(40)
);

CREATE or REPLACE procedure addMovieReview(v_movieName IN varchar, v_comment IN VARCHAR) AS
BEGIN
    INSERT INTO MovieReviews VALUES(v_movieName,v_comment);
END;
/
