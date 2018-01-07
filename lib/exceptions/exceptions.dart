class AutoApiException implements Exception {
	String message = 'Something wrong happen in the AutoAPI library';

	@override
	String toString() {
		return this.message;
	}

}

class DuplicatedHubNameException extends AutoApiException {
	DuplicatedHubNameException(String hubName) {
		this.message = 'Duplicated Hub with name: "$hubName". Hub\'s names have to be unique';
	}
}

class SerializeError extends AutoApiException {
	SerializeError(message) {
		this.message = message;
	}
}

class HubNotFoundException extends AutoApiException {
	HubNotFoundException(hub) {
		this.message = '$hub not found';
	}
}

class MethodNotFoundException extends AutoApiException {
	MethodNotFoundException(hub, method) {
		this.message = 'Method $method not found in $hub';
	}
}