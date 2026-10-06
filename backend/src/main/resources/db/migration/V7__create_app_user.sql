CREATE TABLE app_user (
                          id UUID PRIMARY KEY,

                          username VARCHAR(20) NOT NULL,

                          email VARCHAR(255) NOT NULL,

                          created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

                          updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);