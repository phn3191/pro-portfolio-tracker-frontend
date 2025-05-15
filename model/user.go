package model

import (
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	ClerkID string `gorm:"uniqueIndex" json:"clerk_id"` // Clerk's user ID
	Email   string `json:"email"`
	Name    string `json:"name"`
}
