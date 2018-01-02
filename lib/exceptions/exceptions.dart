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