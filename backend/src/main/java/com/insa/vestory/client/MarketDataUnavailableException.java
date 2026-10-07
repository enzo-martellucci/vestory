package com.insa.vestory.client;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.ErrorResponseException;

public class MarketDataUnavailableException extends ErrorResponseException {

    public MarketDataUnavailableException(String message) {
        this(message, null);
    }

    public MarketDataUnavailableException(String message, Throwable cause) {
        super(HttpStatus.BAD_GATEWAY, ProblemDetail.forStatusAndDetail(HttpStatus.BAD_GATEWAY, message), cause);
    }
}
