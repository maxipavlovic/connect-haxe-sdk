package connect.models;


/**
    Media object represents a media item, like image or video, related to a Product.
**/
class Media extends IdModel {
    public var position: Int;


    /** Inner media type. One of: image, video. **/
    public var type: String;


    /** URL for image or video thumbnail to our Azure media storage. **/
    public var thumbnail: String;


    /** Video URL. **/
    public var url: String;
}
