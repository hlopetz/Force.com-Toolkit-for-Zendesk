// This class provides functionality to call the Zendesk Tags API
/*
Currently supports the following API endpoints:
GET    /api/v2/tags.json
GET    /api/v2/tickets/{id}/tags.json
GET    /api/v2/topics/{id}/tags.json
GET    /api/v2/organizations/{id}/tags.json
GET    /api/v2/users/{id}/tags.json
POST   /api/v2/tickets/{id}/tags.json
POST   /api/v2/topics/{id}/tags.json
POST   /api/v2/organizations/{id}/tags.json
POST   /api/v2/users/{id}/tags.json
PUT    /api/v2/tickets/{id}/tags.json
PUT    /api/v2/topics/{id}/tags.json
PUT    /api/v2/organizations/{id}/tags.json
PUT    /api/v2/users/{id}/tags.json
DELETE /api/v2/tickets/{id}/tags.json
DELETE /api/v2/topics/{id}/tags.json
DELETE /api/v2/organizations/{id}/tags.json
DELETE /api/v2/users/{id}/tags.json
*/
public with sharing class ZendeskTags {

	private final ZendeskAPI zapi;

	public enum Resource { tickets, topics, organizations, users }

	// Used to deserialize the result of a getTags() API call
	public class TagsWrapper extends ZendeskPagingSupport {
		public String[] tags {get; set;}
	}

	// Used to deserialize the result of a listTags() API call
	public class ListTagsWrapper extends ZendeskPagingSupport {
		public ListTags[] tags {get; set;}
	}

	public class ListTags {
		public String name {get; set;}
		public Long count {get; set;}
	}

	public ZendeskTags(ZendeskAPI zapi) {
		this.zapi = zapi;
	}

	public ListTagsWrapper listTags() {
		HttpRequest req = zapi.createRequest('GET', ZendeskAPI.BASE_PATH + '/tags.json');
		String resBody = zapi.sendRequest(req);

		return (ListTagsWrapper)JSON.deserialize(resBody, ListTagsWrapper.class);
	}

	public TagsWrapper getTags(Resource resourceType, Long resourceId) {
		return getTags(resourceType, resourceId, null);
	}

	public TagsWrapper getTags(Resource resourceType, Long resourceId, Long page) {
		if (resourceId == null) { throw new ZendeskException('resourceId parameter must not be null'); }

		HttpRequest req = zapi.createRequest('GET', ZendeskAPI.BASE_PATH + '/' + resourceType.name() + '/' + resourceId + '/tags.json' + (page==null ? '' : '?page=' + page));
		String resBody = zapi.sendRequest(req);

		// { "tags": ["important", "customer"] }
		return (TagsWrapper)JSON.deserialize(resBody, TagsWrapper.class);
	}

	public void setTags(Resource resourceType, Long resourceId, String[] tags) {
		if (resourceId == null) { throw new ZendeskException('resourceId parameter must not be null'); }

		HttpRequest req = zapi.createRequest('POST', ZendeskAPI.BASE_PATH + '/' + resourceType.name() + '/' + resourceId + '/tags.json');
		req.setBody('{ "tags": ' + JSON.serialize(tags) + ' }');
		zapi.sendRequest(req);
	}

	public void addTags(Resource resourceType, Long resourceId, String[] tags) {
		if (resourceId == null) { throw new ZendeskException('resourceId parameter must not be null'); }

		HttpRequest req = zapi.createRequest('PUT', ZendeskAPI.BASE_PATH + '/' + resourceType.name() + '/' + resourceId + '/tags.json');
		req.setBody('{ "tags": ' + JSON.serialize(tags) + ' }');
		zapi.sendRequest(req);
	}

	public void removeTags(Resource resourceType, Long resourceId, String[] tags) {
		if (resourceId == null) { throw new ZendeskException('resourceId parameter must not be null'); }

		HttpRequest req = zapi.createRequest('DELETE', ZendeskAPI.BASE_PATH + '/' + resourceType.name() + '/' + resourceId + '/tags.json');
		req.setBody('{ "tags": ' + JSON.serialize(tags) + ' }');
		zapi.sendRequest(req);
	}
}